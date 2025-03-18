<?php
include("db.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['user_id']) && isset($_POST['anime_id'])) {
        $user_id = $conn->real_escape_string($_POST['user_id']);
        $anime_id = $conn->real_escape_string($_POST['anime_id']);
        
        $delete_sql = "DELETE FROM favorites WHERE user_id = '$user_id' AND anime_id = '$anime_id'";
        $conn->query($delete_sql);

        if ($conn->affected_rows > 0) {
            echo json_encode(["Status" => "True", "Message" => "Removed from favorites"]);
        } else {
            echo json_encode(["Status" => "False", "Message" => "Anime not in favorites"]);
            http_response_code(404);
        }
    } else {
        echo json_encode(["Status" => "False", "Message" => "User ID and Anime ID required"]);
        http_response_code(400);
    }
}

$conn->close();
?>
