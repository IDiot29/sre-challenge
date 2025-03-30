package utils

import (
	"encoding/json"
	"net/http"
	"os"
	"time"
)

type LogEntry struct {
	Timestamp    string      `json:"timestamp"`
	Level        string      `json:"level"`
	Message      string      `json:"message"`
	Method       string      `json:"method,omitempty"`
	Path         string      `json:"path,omitempty"`
	Status       int         `json:"status,omitempty"`
	DurationMs   int64       `json:"duration_ms,omitempty"`
	Context      interface{} `json:"context,omitempty"`
}

func Log(level string, message string, context interface{}) {
	entry := LogEntry{
		Timestamp: time.Now().Format(time.RFC3339),
		Level:     level,
		Message:   message,
		Context:   context,
	}
	json.NewEncoder(os.Stdout).Encode(entry)
}

func Info(message string, context interface{}) {
	Log("info", message, context)
}

func Error(message string, context interface{}) {
	Log("error", message, context)
}

type responseWriter struct {
	http.ResponseWriter
	status int
}

func (rw *responseWriter) WriteHeader(code int) {
	rw.status = code
	rw.ResponseWriter.WriteHeader(code)
}

// LoggingMiddleware logs each request in JSON
func LoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		rw := &responseWriter{ResponseWriter: w, status: 200}

		next.ServeHTTP(rw, r)

		duration := time.Since(start).Milliseconds()
		entry := LogEntry{
			Timestamp:  time.Now().Format(time.RFC3339),
			Level:      "info",
			Message:    "request",
			Method:     r.Method,
			Path:       r.URL.Path,
			Status:     rw.status,
			DurationMs: duration,
		}
		json.NewEncoder(os.Stdout).Encode(entry)
	})
}

