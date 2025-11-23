console.log("NotesApp frontend loaded");

window.onload = function() {
    // URL of the API endpoint to fetch notes (you may need to adjust the URL depending on your setup)
    const apiUrl = "http://notes.192.168.49.2.nip.io/notes";  // 

    // Fetch the notes from the API
    fetch(apiUrl)
        .then(response => response.json())  // Assuming the API returns a JSON array of notes
        .then(notes => {
            const notesDiv = document.getElementById("notes");
            if (notes.length === 0) {
                notesDiv.innerHTML = "<p>No notes available.</p>";
            } else {
                const notesList = document.createElement("ul");
                notes.forEach(note => {
                    const noteItem = document.createElement("li");
                    noteItem.textContent = note.content;  // Assuming each note has a 'content' field
                    notesList.appendChild(noteItem);
                });
                notesDiv.appendChild(notesList);
            }
        })
        .catch(error => {
            console.error("Error fetching notes:", error);
        });
};

