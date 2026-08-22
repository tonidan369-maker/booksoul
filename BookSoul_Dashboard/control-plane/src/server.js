import cors from 'cors';
import express from 'express';
import helmet from 'helmet';

const app = express();
const port = Number(process.env.PORT || 8080);
const controlToken = process.env.CONTROL_PLANE_TOKEN || '';
const dashboardOrigin = process.env.DASHBOARD_ORIGIN || '';
const supabaseUrl = process.env.SUPABASE_URL || '';
const mcpServerUrl = process.env.MCP_SERVER_URL || '';
const modelProvider = process.env.MODEL_PROVIDER || '';

app.use(helmet());
app.use(express.json({ limit: '64kb' }));
app.use(cors({ origin: dashboardOrigin ? [dashboardOrigin] : false, methods: ['GET', 'POST'] }));

function requireAdmin(req, res, next) {
  if (!controlToken) return res.status(503).json({ error: 'CONTROL_PLANE_TOKEN is not configured' });
  const authorization = req.get('authorization') || '';
  if (authorization !== `Bearer ${controlToken}`) return res.status(401).json({ error: 'Unauthorized' });
  return next();
}

app.get('/healthz', (_, res) => res.status(200).type('text').send('ok\n'));

app.get('/api/status', requireAdmin, (_, res) => {
  res.json({
    service: 'booksoul-control-plane',
    status: 'ready',
    integrations: {
      supabase: Boolean(supabaseUrl),
      mcp: Boolean(mcpServerUrl),
      modelProvider: modelProvider || 'not-configured',
    },
  });
});

app.post('/api/api-tests', requireAdmin, async (req, res) => {
  const target = String(req.body?.target || 'self');
  const allowedTargets = {
    self: `http://127.0.0.1:${port}/healthz`,
    supabase: supabaseUrl ? `${supabaseUrl}/rest/v1/` : '',
    mcp: mcpServerUrl,
  };
  const url = allowedTargets[target];
  if (!url) return res.status(400).json({ error: 'Unknown or unconfigured test target' });
  const startedAt = Date.now();
  try {
    const response = await fetch(url, { method: 'GET', signal: AbortSignal.timeout(8000) });
    return res.json({ target, ok: response.ok, status: response.status, elapsedMs: Date.now() - startedAt });
  } catch (error) {
    return res.status(502).json({ target, ok: false, elapsedMs: Date.now() - startedAt, error: String(error) });
  }
});

app.get('/api/integrations', requireAdmin, (_, res) => {
  res.json({
    mcp: { configured: Boolean(mcpServerUrl), endpoint: mcpServerUrl ? 'configured' : 'not-configured' },
    modelProvider: { configured: Boolean(modelProvider), provider: modelProvider || 'not-configured' },
    notifications: { configured: Boolean(supabaseUrl) },
  });
});

app.post('/api/agent/chat', requireAdmin, (req, res) => {
  const message = String(req.body?.message || '').trim();
  if (!message || message.length > 2000) return res.status(400).json({ error: 'Message must be between 1 and 2000 characters' });
  // Deliberately returns a non-executing plan. Connect a reviewed tool executor before enabling mutations.
  return res.json({ mode: 'plan', reply: `تم استلام الطلب: «${message}». وضع الأمان الحالي ينشئ خطة فقط ولا ينفذ تغييرات على التطبيق أو البنية دون سياسة أدوات ومصادقة مفعلة.` });
});

app.use((_, res) => res.status(404).json({ error: 'Not found' }));
app.listen(port, '0.0.0.0', () => console.log(`BookSoul control plane listening on ${port}`));
