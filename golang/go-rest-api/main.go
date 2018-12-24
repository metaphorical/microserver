package main

import (
    "encoding/json"
    "log"
    "net/http"
    "github.com/gorilla/mux"
)

type record struct {
    Id string
}
type message struct {
	Message string
}

func GetRoot(w http.ResponseWriter, r *http.Request) {
	result_message := message{Message: "Hello World!"}
	json.NewEncoder(w).Encode(result_message)
}

func GetId(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id := params["id"]
	result_record := record{Id: id}
	json.NewEncoder(w).Encode(result_record)
}


func main() {
    router := mux.NewRouter()
    router.HandleFunc("/", GetRoot).Methods("GET")
	router.HandleFunc("/{id}", GetId).Methods("GET")
	
    log.Fatal(http.ListenAndServe(":8000", router))
}