const { createProxyMiddleware } = require('http-proxy-middleware');
const express = require('express');
const app = express();

app.use('/api', createProxyMiddleware({
  target: 'https://uasdapi.ia3x.com',
  changeOrigin: true,
  pathRewrite: {
    '^/api': '',
  },
}));

app.listen(3000, () => {
  console.log('Proxy server is running on http://localhost:3000');
});