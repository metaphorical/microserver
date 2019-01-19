package main

import (
	"net/http"
	"encoding/json"
    "log"

	"github.com/gin-gonic/gin"

	"github.com/parnurzeal/gorequest"
)

// Preparing a structure to parse and output data from bgg api
type Game struct {
	Rank string
	GameId string
	Name string
	Thumbnail string
  }

func setupRouter() *gin.Engine {
	// Disable Console Color
	// gin.DisableConsoleColor()
	r := gin.Default()
	request := gorequest.New()

	// health route
	r.GET("/healthy", func(c *gin.Context) {
			c.Writer.Header().Set("x-Health", "Awsome")
			c.JSON(http.StatusOK, gin.H{"message": "Everything is awesome"})
	})

	// bgg hot route
	r.GET("/bgg/hot", func(c *gin.Context) {

		_, body, err := request.Get("https://bgg-json.azurewebsites.net/hot").End()

		if err != nil {
			panic(err)
		}

		var gameArr []Game

		_ = json.Unmarshal([]byte(body), &gameArr)
		log.Printf("Request to bgg hot done")

		c.JSON(http.StatusOK, gameArr)
	})

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "Everything is awesome"})
	})



	return r
}

func main() {
	r := setupRouter()
	// Listen and Server in 0.0.0.0:9000
	r.Run(":9000")
}
