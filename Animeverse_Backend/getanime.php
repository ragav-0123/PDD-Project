<?php
include("db.php");
header("Content-Type: application/json");

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if anime_id is provided
    if (isset($_POST['anime_id'])) {
        $anime_id = intval($_POST['anime_id']); // Convert to integer for security

        // Fetch anime details
        $sql = "SELECT anime_id, anime_name, total_episodes, genres, description, rating FROM anime WHERE anime_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $anime_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $animeData = $result->fetch_assoc();
        $stmt->close();

        // If anime exists, fetch its episodes
        if ($animeData) {
            $sql = "SELECT episode_number, title, type FROM episodes WHERE anime_id = ? ORDER BY episode_number ASC";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("i", $anime_id);
            $stmt->execute();
            $result = $stmt->get_result();
            
            $episodes = [];
            while ($row = $result->fetch_assoc()) {
                $episodes[] = $row;
            }
            $stmt->close();

            // Add episodes to anime data
            $animeData["episodes"] = $episodes;

            // Send success response
            echo json_encode([
                "Status" => "True",
                "Message" => "Anime data retrieved successfully.",
                "Data" => $animeData
            ]);
            http_response_code(200);
        } else {
            // Anime not found
            echo json_encode([
                "Status" => "False",
                "Message" => "Anime not found.",
                "Data" => []
            ]);
            http_response_code(404);
        }
    } else {
        // Missing anime_id
        echo json_encode([
            "Status" => "False",
            "Message" => "anime_id is required.",
            "Data" => []
        ]);
        http_response_code(400);
    }
} else {
    // Invalid request method
    echo json_encode([
        "Status" => "False",
        "Message" => "Invalid request method.",
        "Data" => []
    ]);
    http_response_code(405);
}
?>
