const request = require('supertest');
const app = require('../src/index');

describe('Health Check', () => {

  it('GET /health should return 200 or 503', async () => {
    const res = await request(app).get('/health');
    expect([200, 503]).toContain(res.statusCode);
    expect(res.body.app).toBe('brewer');
  });

  it('GET /metrics should return prometheus metrics', async () => {
    const res = await request(app).get('/metrics');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('brewer_http_requests_total');
  });

});
