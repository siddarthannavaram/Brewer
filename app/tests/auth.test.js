const request = require('supertest');
const app = require('../src/index');

describe('Auth Routes', () => {

  describe('POST /api/auth/register', () => {

    it('should return 400 if fields are missing', async () => {
      const res = await request(app)
        .post('/api/auth/register')
        .send({ email: 'test@test.com' });
      expect(res.statusCode).toBe(400);
      expect(res.body.error).toBeDefined();
    });

    it('should return 400 if password is too short', async () => {
      const res = await request(app)
        .post('/api/auth/register')
        .send({ name: 'Test', email: 'test@test.com', password: '123' });
      expect(res.statusCode).toBe(400);
      expect(res.body.error).toMatch(/6 characters/);
    });

  });

  describe('POST /api/auth/login', () => {

    it('should return 400 if fields are missing', async () => {
      const res = await request(app)
        .post('/api/auth/login')
        .send({ email: 'test@test.com' });
      expect(res.statusCode).toBe(400);
      expect(res.body.error).toBeDefined();
    });

    it('should return 401 for wrong credentials', async () => {
      const res = await request(app)
        .post('/api/auth/login')
        .send({ email: 'nobody@nowhere.com', password: 'wrongpass' });
      expect(res.statusCode).toBe(401);
    });

  });

});
