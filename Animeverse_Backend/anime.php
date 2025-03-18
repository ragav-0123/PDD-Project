<?php
include("db.php");
header("Content-Type: application/json");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Load JSON data
$jsonData = file_get_contents('info1.json');
$data = json_decode($jsonData, true);

$anime_id = $data['anime_id'];

// Insert anime data (only if not already present)
$sql = "SELECT COUNT(*) AS count FROM anime WHERE anime_id = $anime_id";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
if ($row['count'] == 0) {
    $anime_name = $data['anime_name'];
    $total_episodes = $data['total_episodes'];
    $genres = $data['genres'];

    $sql = "INSERT INTO anime (anime_id, anime_name, total_episodes, genres) 
            VALUES ($anime_id, '$anime_name', $total_episodes, '$genres')";
    $conn->query($sql);
}

// Insert only new episodes
foreach ($data['episodes'] as $episode) {
    $episode_number = $episode['episode_number'];
    $title = $conn->real_escape_string($episode['title']); // Prevent SQL injection
    $type = $episode['type'];

    // Check if episode already exists
    $checkSql = "SELECT COUNT(*) AS count FROM episodes WHERE anime_id = $anime_id AND episode_number = $episode_number";
    $checkResult = $conn->query($checkSql);
    $checkRow = $checkResult->fetch_assoc();

    if ($checkRow['count'] == 0) {
        // Insert new episode
        $sql = "INSERT INTO episodes (anime_id, episode_number, title, type) 
                VALUES ($anime_id, $episode_number, '$title', '$type')";
        if ($conn->query($sql) === TRUE) {
            echo "Inserted episode $episode_number: $title<br>";
        } else {
            echo "Error: " . $conn->error . "<br>";
        }
    } else {
        echo "Skipping duplicate episode $episode_number: $title<br>";
    }
}

$conn->close();
?>
