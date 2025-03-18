<?php
include("db.php");
header("Content-Type: application/json");

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate user_id input
    if (isset($_POST['user_id'])) {
        $user_id = intval($_POST['user_id']);
        
        // Query to fetch user details
        $sql = "SELECT user_id, name, email, age FROM register WHERE user_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
            
            echo json_encode([
                "Status" => "True",
                "Message" => "User profile fetched successfully.",
                "Data" => $user
            ]);
        } else {
            echo json_encode([
                "Status" => "False",
                "Message" => "User not found.",
                "Data" => []
            ]);
        }
        
        $stmt->close();
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "Missing user_id parameter.",
            "Data" => []
        ]);
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
