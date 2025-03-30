package tests

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"pixelpet/controllers"
	"pixelpet/models"
	"pixelpet/utils"

	"github.com/gorilla/mux"
)

func init() {
	utils.ConnectDB()
}

func TestCreatePet(t *testing.T) {
	router := mux.NewRouter()
	router.HandleFunc("/pets", controllers.CreatePet).Methods("POST")

	pet := models.Pet{Name: "Testy", Happiness: 80, Hunger: 20, Energy: 90}
	payload, _ := json.Marshal(pet)

	req, _ := http.NewRequest("POST", "/pets", bytes.NewBuffer(payload))
	req.Header.Set("Content-Type", "application/json")
	res := httptest.NewRecorder()

	router.ServeHTTP(res, req)

	if res.Code != http.StatusOK {
		t.Errorf("expected status 200, got %v", res.Code)
	}
}

func TestGetAllPets(t *testing.T) {
	router := mux.NewRouter()
	router.HandleFunc("/pets", controllers.GetAllPets).Methods("GET")

	req, _ := http.NewRequest("GET", "/pets", nil)
	res := httptest.NewRecorder()

	router.ServeHTTP(res, req)

	if res.Code != http.StatusOK {
		t.Errorf("expected status 200, got %v", res.Code)
	}
}

