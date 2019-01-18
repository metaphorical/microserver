package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func setupRouter() *gin.Engine {
	// Disable Console Color
	// gin.DisableConsoleColor()
	r := gin.Default()

	// Ping test
	r.GET("/ping", func(c *gin.Context) {
		c.String(http.StatusOK, "pong")
	})

	// health route
	r.GET("/healthy", func(c *gin.Context) {
			c.Writer.Header().Set("x-Health", "Awsome")
			c.JSON(http.StatusOK, gin.H{"message": "Everything is awesome"})
	})


	return r
}

func main() {
	r := setupRouter()
	// Listen and Server in 0.0.0.0:8080
	r.Run(":9000")
}
