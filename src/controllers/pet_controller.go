package controllers

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"pixelpet/models"
	"pixelpet/utils"

	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func CreatePet(w http.ResponseWriter, r *http.Request) {
	var pet models.Pet
	_ = json.NewDecoder(r.Body).Decode(&pet)
	pet.ID = primitive.NewObjectID()

	collection := utils.GetCollection("pets")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := collection.InsertOne(ctx, pet)
	if err != nil {
		http.Error(w, "Failed to create pet", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(pet)
}

func GetAllPets(w http.ResponseWriter, r *http.Request) {
	collection := utils.GetCollection("pets")
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, "Failed to fetch pets", http.StatusInternalServerError)
		return
	}
	var pets []models.Pet
	if err = cursor.All(ctx, &pets); err != nil {
		http.Error(w, "Failed to decode pets", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(pets)
}

func GetPetByID(w http.ResponseWriter, r *http.Request) {
	idParam := mux.Vars(r)["id"]
	id, _ := primitive.ObjectIDFromHex(idParam)

	var pet models.Pet
	collection := utils.GetCollection("pets")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	err := collection.FindOne(ctx, bson.M{"_id": id}).Decode(&pet)
	if err != nil {
		http.Error(w, "Pet not found", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(pet)
}

func UpdatePet(w http.ResponseWriter, r *http.Request) {
	idParam := mux.Vars(r)["id"]
	id, _ := primitive.ObjectIDFromHex(idParam)

	var pet models.Pet
	_ = json.NewDecoder(r.Body).Decode(&pet)

	collection := utils.GetCollection("pets")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := collection.UpdateOne(ctx, bson.M{"_id": id}, bson.M{"$set": pet})
	if err != nil {
		http.Error(w, "Failed to update pet", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(pet)
}

func DeletePet(w http.ResponseWriter, r *http.Request) {
	idParam := mux.Vars(r)["id"]
	id, _ := primitive.ObjectIDFromHex(idParam)

	collection := utils.GetCollection("pets")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := collection.DeleteOne(ctx, bson.M{"_id": id})
	if err != nil {
		http.Error(w, "Failed to delete pet", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

