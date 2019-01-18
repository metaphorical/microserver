#include <kore/kore.h>
#include <kore/http.h>

int		root_handler(struct http_request *);
int		health_handler(struct http_request *);
int		bgg_hot_handler(struct http_request *);

int
root_handler(struct http_request *req)
{
	char *hello = "{ \"message\": \"kore api 1.0\"}";
	http_response(req, 200, hello, strlen(hello));
	return (KORE_RESULT_OK);
}

int
health_handler(struct http_request *req)
{
	char *health_response = "{ \"message\": \"everything is awsome (tm)\"}";
	http_response_header(req, "X-Health", "Awsome");
	http_response(req, 200, health_response, strlen(health_response));
	return (KORE_RESULT_OK);
}

int
bgg_hot_handler(struct http_request *req)
{
	char *health_response = "{ \"message\": \"hot bgg response goes here\"}";
	http_response_header(req, "content-type", "application/json");
	http_response(req, 200, health_response, strlen(health_response));
	return (KORE_RESULT_OK);
}
