<?php
include("db.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['comment_id']) && isset($_POST['user_id'])) {
        $comment_id = $conn->real_escape_string($_POST['comment_id']);
        $user_id = $conn->real_escape_string($_POST['user_id']);

        // Check if the user has already liked the comment
        $checkLikeQuery = "SELECT * FROM comment_likes WHERE comment_id = '$comment_id' AND user_id = '$user_id'";
        $result = $conn->query($checkLikeQuery);

        if ($result->num_rows > 0) {
            // Unlike the comment
            $unlikeQuery = "DELETE FROM comment_likes WHERE comment_id = '$comment_id' AND user_id = '$user_id'";
            if ($conn->query($unlikeQuery)) {
                echo json_encode([
                    "Status" => "True",
                    "Message" => "Like removed successfully.",
                    "Data" => []
                ]);
            } else {
                echo json_encode([
                    "Status" => "False",
                    "Message" => "Failed to remove like.",
                    "Data" => []
                ]);
            }
        } else {
            // Like the comment
            $likeQuery = "INSERT INTO comment_likes (comment_id, user_id) VALUES ('$comment_id', '$user_id')";
            if ($conn->query($likeQuery)) {
                echo json_encode([
                    "Status" => "True",
                    "Message" => "Comment liked successfully.",
                    "Data" => []
                ]);
            } else {
                echo json_encode([
                    "Status" => "False",
                    "Message" => "Failed to like comment.",
                    "Data" => []
                ]);
            }
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
