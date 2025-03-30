package routes

import (
	"pixelpet/controllers"

	"github.com/gorilla/mux"
)

func RegisterPetRoutes(r *mux.Router) {
	r.HandleFunc("/pets", controllers.CreatePet).Methods("POST")
	r.HandleFunc("/pets", controllers.GetAllPets).Methods("GET")
	r.HandleFunc("/pets/{id}", controllers.GetPetByID).Methods("GET")
	r.HandleFunc("/pets/{id}", controllers.UpdatePet).Methods("PUT")
	r.HandleFunc("/pets/{id}", controllers.DeletePet).Methods("DELETE")
}

