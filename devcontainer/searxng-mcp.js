#!/usr/bin/env node
// MCP server that exposes SearXNG as a web_search tool for Claude Code

const SEARXNG_URL = process.env.SEARXNG_URL || 'http://searxng:8080';

const readline = require('readline');

const rl = readline.createInterface({ input: process.stdin, terminal: false });

let inputBuffer = '';

rl.on('line', async (line) => {
  inputBuffer += line;
  let msg;
  try {
    msg = JSON.parse(inputBuffer);
    inputBuffer = '';
  } catch {
    return;
  }
  await handle(msg);
});

async function handle(msg) {
  const { id, method, params } = msg;

  if (method === 'initialize') {
    reply(id, {
      protocolVersion: '2024-11-05',
      capabilities: { tools: {} },
      serverInfo: { name: 'searxng-mcp', version: '1.0.0' },
    });
    return;
  }

  if (method === 'notifications/initialized') return;

  if (method === 'tools/list') {
    reply(id, {
      tools: [
        {
          name: 'web_search',
          description:
            'Search the web via SearXNG. Returns titles, URLs, and snippets from multiple search engines.',
          inputSchema: {
            type: 'object',
            properties: {
              query: { type: 'string', description: 'Search query' },
              categories: {
                type: 'string',
                description: 'Comma-separated categories: general, news, images, science, files',
                default: 'general',
              },
              language: {
                type: 'string',
                description: 'Language code, e.g. "en", "nl", "auto"',
                default: 'auto',
              },
              max_results: {
                type: 'number',
                description: 'Max results to return (1-20)',
                default: 10,
              },
            },
            required: ['query'],
          },
        },
      ],
    });
    return;
  }

  if (method === 'tools/call') {
    const { name, arguments: args } = params;
    if (name !== 'web_search') {
      reply(id, { content: [{ type: 'text', text: `Unknown tool: ${name}` }], isError: true });
      return;
    }

    const query = args.query;
    const categories = args.categories || 'general';
    const language = args.language || 'auto';
    const maxResults = Math.min(Math.max(parseInt(args.max_results || 10), 1), 20);

    try {
      const url = new URL('/search', SEARXNG_URL);
      url.searchParams.set('q', query);
      url.searchParams.set('categories', categories);
      url.searchParams.set('language', language);
      url.searchParams.set('format', 'json');

      const res = await fetch(url.toString(), {
        headers: { Accept: 'application/json' },
        signal: AbortSignal.timeout(10000),
      });

      if (!res.ok) {
        throw new Error(`SearXNG returned HTTP ${res.status}`);
      }

      const data = await res.json();
      const results = (data.results || []).slice(0, maxResults).map((r) => ({
        title: r.title,
        url: r.url,
        snippet: r.content || '',
        engine: r.engine,
      }));

      const text =
        results.length === 0
          ? 'No results found.'
          : results
              .map(
                (r, i) =>
                  `[${i + 1}] ${r.title}\n    URL: ${r.url}\n    ${r.snippet}`
              )
              .join('\n\n');

      reply(id, { content: [{ type: 'text', text }] });
    } catch (err) {
      reply(id, {
        content: [{ type: 'text', text: `Search failed: ${err.message}` }],
        isError: true,
      });
    }
    return;
  }

  // Unknown method
  replyError(id, -32601, `Method not found: ${method}`);
}

function reply(id, result) {
  process.stdout.write(JSON.stringify({ jsonrpc: '2.0', id, result }) + '\n');
}

function replyError(id, code, message) {
  process.stdout.write(
    JSON.stringify({ jsonrpc: '2.0', id, error: { code, message } }) + '\n'
  );
}
