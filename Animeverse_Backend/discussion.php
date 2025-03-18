<?php
include("db.php");
header("Content-Type: application/json");

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if user_id and comment are provided
    if (isset($_POST['user_id']) && isset($_POST['comment'])) {
        $user_id = $conn->real_escape_string($_POST['user_id']);
        $comment = $conn->real_escape_string($_POST['comment']);

        // Ensure comment is not empty
        if (trim($comment) === "") {
            echo json_encode([
                "Status" => "False",
                "Message" => "Comment cannot be empty.",
                "Data" => []
            ]);
            http_response_code(400);
            exit;
        }

        // Insert comment into the database
        $sql = "INSERT INTO crew_discuss (user_id, comment) VALUES ('$user_id', '$comment')";
        if ($conn->query($sql)) {
            echo json_encode([
                "Status" => "True",
                "Message" => "Comment posted successfully.",
                "Data" => [
                    "comment_id" => $conn->insert_id,
                    "user_id" => $user_id,
                    "comment" => $comment
                ]
            ]);
            http_response_code(201);
        } else {
            echo json_encode([
                "Status" => "False",
                "Message" => "Error: " . $conn->error,
                "Data" => []
            ]);
            http_response_code(500);
        }
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "User ID and comment are required.",
            "Data" => []
        ]);
        http_response_code(400);
    }
} else {
    echo json_encode([
        "Status" => "False",
        "Message" => "Invalid request method.",
        "Data" => []
    ]);
    http_response_code(405);
}
?>
