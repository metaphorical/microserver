const request = require('supertest');

const server = require("../server.js");


// close the server after each test
afterEach(() => {
  server.close();
});
describe("routes: bgg/hot", () => {
  test("should respond with json", async () => {
    const response = await request(server).get("/bgg/hot");
    expect(response.status).toEqual(200);
    expect(response.type).toEqual("application/json");
  });
});