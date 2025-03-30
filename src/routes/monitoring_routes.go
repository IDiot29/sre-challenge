package routes

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// RegisterMonitoringRoutes registers /healthcheck and /metrics
func RegisterMonitoringRoutes(r *mux.Router) {
	r.HandleFunc("/healthcheck", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	}).Methods("GET")

	r.Handle("/metrics", promhttp.Handler())
}

