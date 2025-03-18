<?php
include("db.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['user_id']) && isset($_POST['anime_id'])) {
        $user_id = $conn->real_escape_string($_POST['user_id']);
        $anime_id = $conn->real_escape_string($_POST['anime_id']);
        
        // Check if anime exists
        $check_anime_sql = "SELECT anime_id FROM anime WHERE anime_id = '$anime_id'";
        $anime_result = $conn->query($check_anime_sql);
        
        if ($anime_result->num_rows == 0) {
            echo json_encode(["Status" => "False", "Message" => "Anime not found"]);
            http_response_code(404);
            exit;
        }
        
        // Check if already in favorites
        $check_sql = "SELECT favorite_id FROM favorites WHERE user_id = '$user_id' AND anime_id = '$anime_id'";
        $check_result = $conn->query($check_sql);
        
        if ($check_result->num_rows > 0) {
            echo json_encode(["Status" => "False", "Message" => "Anime already in favorites"]);
            http_response_code(409);
        } else {
            $insert_sql = "INSERT INTO favorites (user_id, anime_id, date_added) VALUES ('$user_id', '$anime_id', NOW())";
            if ($conn->query($insert_sql) === TRUE) {
                echo json_encode(["Status" => "True", "Message" => "Added to favorites", "Data" => ["favorite_id" => $conn->insert_id]]);
                http_response_code(201);
            } else {
                echo json_encode(["Status" => "False", "Message" => "Failed to add: " . $conn->error]);
                http_response_code(500);
            }
        }
    } else {
        echo json_encode(["Status" => "False", "Message" => "User ID and Anime ID required"]);
        http_response_code(400);
    }
}

$conn->close();
?>
