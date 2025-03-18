<?php
include("db.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['user_id'])) {
        $user_id = $conn->real_escape_string($_POST['user_id']);
        
        $sql = "SELECT f.favorite_id, f.anime_id, a.anime_name, a.genres, a.total_episodes 
                FROM favorites f
                JOIN anime a ON f.anime_id = a.anime_id
                WHERE f.user_id = '$user_id'
                ORDER BY f.date_added DESC";
        
        $result = $conn->query($sql);
        $favorites = [];

        while ($row = $result->fetch_assoc()) {
            $favorites[] = $row;
        }

        echo json_encode([
            "Status" => "True",
            "Message" => count($favorites) > 0 ? "Favorites retrieved successfully" : "No favorites found",
            "Data" => $favorites
        ]);
    } else {
        echo json_encode(["Status" => "False", "Message" => "User ID required"]);
        http_response_code(400);
    }
}

$conn->close();
?>
