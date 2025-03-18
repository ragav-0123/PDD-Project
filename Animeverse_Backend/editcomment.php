<?php
include("db.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['comment_id']) && isset($_POST['user_id']) && isset($_POST['new_content'])) {
        $comment_id = $conn->real_escape_string($_POST['comment_id']);
        $user_id = $conn->real_escape_string($_POST['user_id']);
        $new_content = $conn->real_escape_string($_POST['new_content']);

        // Check if the comment exists and belongs to the user
        $checkQuery = "SELECT * FROM comments WHERE comment_id = '$comment_id' AND user_id = '$user_id'";
        $result = $conn->query($checkQuery);

        if ($result->num_rows > 0) {
            // Update the comment
            $updateQuery = "UPDATE comments SET content = '$new_content', updated_at = NOW() WHERE comment_id = '$comment_id'";
            if ($conn->query($updateQuery)) {
                echo json_encode([
                    "Status" => "True",
                    "Message" => "Comment updated successfully.",
                    "Data" => []
                ]);
            } else {
                echo json_encode([
                    "Status" => "False",
                    "Message" => "Failed to update comment.",
                    "Data" => []
                ]);
            }
        } else {
            echo json_encode([
                "Status" => "False",
                "Message" => "Comment not found or you do not have permission to edit it.",
                "Data" => []
            ]);
        }
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "Invalid input or missing required fields.",
            "Data" => []
        ]);
    }
} else {
    echo json_encode([
        "Status" => "False",
        "Message" => "Invalid request method.",
        "Data" => []
    ]);
}
?>
