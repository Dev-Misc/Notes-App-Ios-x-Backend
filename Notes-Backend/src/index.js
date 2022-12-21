const express = require("express");
const fs = require("fs");

require("./db/mongoose");

const Note = require("./models/notes");
const app = express();

app.use(express.json());

//Create
app.post("/notes", async (req, res) => {
  const note = new Note(req.body);
  try {
    await note.save();
    res.status(201).send(note);
  } catch (err) {
    res.status(400).send(err);
  }
});

//Get Notes
app.get("/getNotes", async (req, res) => {
  try {
    const notes = await Note.find({});
    res.send(notes);
  } catch (err) {
    res.status(400).send(err);
  }
});

//Update Notes
app.patch("/notes/:id", async (req, res) => {
  try {
    const data = req.body.note;
    const notx = await Note.findById(req.params.id);

    if(!notx)
    {
        return res.status(404).send()
    }

    notx.note = data;

    await notx.save();

    res.status(201).send(notx);
  } catch (err) {
    res.status(400).send(err);
  }
});

//Update
app.delete("/delete/:id", async (req, res) => {
  try {

    const notx = await Note.findByIdAndDelete(req.params.id);

    if(!notx)
    {
        return res.status(404).send()
    }
 
    res.send("The Note Has Been Deleted")

  } catch (err) 
  {
    res.status(500).send(err);
  }
});

app.listen(3000, () => {
  console.log("API Is Live");
});
