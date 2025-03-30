package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Pet struct {
	ID        primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Name      string             `json:"name" bson:"name"`
	Happiness int                `json:"happiness" bson:"happiness"`
	Hunger    int                `json:"hunger" bson:"hunger"`
	Energy    int                `json:"energy" bson:"energy"`
}

