package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"pixelpet/routes"
	"pixelpet/utils"
)

func main() {
	utils.ConnectDB()

	r := mux.NewRouter()

	// Log all HTTP requests
	r.Use(utils.LoggingMiddleware)

	// Root
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("👋 Pixel Pet API is up! Try /pets"))
	})

	// Routes
	routes.RegisterMonitoringRoutes(r)
	routes.RegisterPetRoutes(r)

	utils.Info("Pixel Pet API is running on port 8080 🚀", nil)
	log.Fatal(http.ListenAndServe(":8080", r))
}

