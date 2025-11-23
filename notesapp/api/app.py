from flask import Flask, request, jsonify
import psycopg2
import os

app = Flask(__name__)

# Configuration: PostgreSQL connection settings
DB_HOST = os.environ.get("DB_HOST", "localhost")  # Default to localhost if not set
DB_NAME = os.environ.get("DB_NAME", "notes")     # Database name
DB_USER = os.environ.get("DB_USER", "postgres")  # PostgreSQL user (using peer auth)
DB_PASS = os.environ.get("DB_PASS", "")          # Empty because we're using peer authentication

# Function to establish a database connection
def get_conn():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )

# Route to get all notes
@app.route("/notes", methods=["GET"])
def get_notes():
    try:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("SELECT id, content FROM notes;")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify(rows), 200  # Return notes as a JSON response
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to add a new note
@app.route("/add", methods=["POST"])
def add_note():
    try:
        content = request.json.get("content")  # Get content from the POST request
        if not content:
            return jsonify({"error": "Content is required"}), 400

        conn = get_conn()
        cur = conn.cursor()
        cur.execute("INSERT INTO notes (content) VALUES (%s);", (content,))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"status": "ok"}), 201  # Return success status
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to delete a note by ID
@app.route("/delete/<int:id>", methods=["DELETE"])
def delete_note(id):
    try:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("DELETE FROM notes WHERE id=%s;", (id,))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"status": "deleted"}), 200  # Return success status
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)  # Expose on all interfaces (0.0.0.0) and port 5000

