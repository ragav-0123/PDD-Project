<?php
include("db.php");
header("Content-Type: application/json");

// Check request method
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Get user's favorite anime list
    if (isset($_GET['user_id'])) {
        $user_id = $conn->real_escape_string($_GET['user_id']);
        
        $sql = "SELECT f.favorite_id, f.anime_id, a.anime_name, a.genres, a.total_episodes 
                FROM favorites f
                JOIN anime a ON f.anime_id = a.anime_id
                WHERE f.user_id = '$user_id'
                ORDER BY f.date_added DESC";
        
        $result = $conn->query($sql);
        
        if ($result && $result->num_rows > 0) {
            $favorites = [];
            while ($row = $result->fetch_assoc()) {
                $favorites[] = $row;
            }
            
            echo json_encode([
                "Status" => "True",
                "Message" => "Favorites retrieved successfully.",
                "Data" => $favorites
            ]);
        } else {
            echo json_encode([
                "Status" => "True",
                "Message" => "No favorites found for this user.",
                "Data" => []
            ]);
        }
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "User ID is required.",
            "Data" => []
        ]);
        http_response_code(400);
    }
} 
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Add anime to favorites
    if (isset($_POST['user_id']) && isset($_POST['anime_id'])) {
        $user_id = $conn->real_escape_string($_POST['user_id']);
        $anime_id = $conn->real_escape_string($_POST['anime_id']);
        
        // Check if anime exists
        $check_anime_sql = "SELECT anime_id FROM anime WHERE anime_id = '$anime_id'";
        $anime_result = $conn->query($check_anime_sql);
        
        if ($anime_result->num_rows == 0) {
            echo json_encode([
                "Status" => "False",
                "Message" => "Anime with ID $anime_id does not exist.",
                "Data" => []
            ]);
            http_response_code(404);
            $conn->close();
            exit;
        }
        
        // Check if already in favorites
        $check_sql = "SELECT favorite_id FROM favorites 
                      WHERE user_id = '$user_id' AND anime_id = '$anime_id'";
        $check_result = $conn->query($check_sql);
        
        if ($check_result->num_rows > 0) {
            echo json_encode([
                "Status" => "False",
                "Message" => "Anime already in favorites.",
                "Data" => []
            ]);
            http_response_code(409);
        } else {
            // Add to favorites with current timestamp
            $insert_sql = "INSERT INTO favorites (user_id, anime_id, date_added) 
                          VALUES ('$user_id', '$anime_id', NOW())";
            
            if ($conn->query($insert_sql) === TRUE) {
                echo json_encode([
                    "Status" => "True",
                    "Message" => "Added to favorites successfully.",
                    "Data" => ["favorite_id" => $conn->insert_id, "anime_id" => $anime_id]
                ]);
                http_response_code(201);
            } else {
                echo json_encode([
                    "Status" => "False",
                    "Message" => "Failed to add to favorites: " . $conn->error,
                    "Data" => []
                ]);
                http_response_code(500);
            }
        }
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "User ID and Anime ID are required.",
            "Data" => []
        ]);
        http_response_code(400);
    }
} 
elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    // Parse DELETE request parameters
    parse_str(file_get_contents("php://input"), $delete_vars);
    
    // Remove from favorites
    if (isset($delete_vars['user_id']) && isset($delete_vars['anime_id'])) {
        $user_id = $conn->real_escape_string($delete_vars['user_id']);
        $anime_id = $conn->real_escape_string($delete_vars['anime_id']);
        
        $delete_sql = "DELETE FROM favorites 
                       WHERE anime_id = '$anime_id' AND user_id = '$user_id'";
        
        if ($conn->query($delete_sql) === TRUE) {
            if ($conn->affected_rows > 0) {
                echo json_encode([
                    "Status" => "True",
                    "Message" => "Removed from favorites successfully.",
                    "Data" => []
                ]);
            } else {
                echo json_encode([
                    "Status" => "False",
                    "Message" => "Anime not found in favorites.",
                    "Data" => []
                ]);
                http_response_code(404);
            }
        } else {
            echo json_encode([
                "Status" => "False",
                "Message" => "Failed to remove from favorites: " . $conn->error,
                "Data" => []
            ]);
            http_response_code(500);
        }
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "User ID and Anime ID are required.",
            "Data" => []
        ]);
        http_response_code(400);
    }
} 
else {
    // Invalid request method
    echo json_encode([
        "Status" => "False",
        "Message" => "Invalid request method. Supported methods: GET, POST, DELETE",
        "Data" => []
    ]);
    http_response_code(405);
}

$conn->close();
?>