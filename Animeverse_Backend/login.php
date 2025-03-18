<?php
include("db.php");
header("Content-Type: application/json");

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if email and password are provided
    if (isset($_POST['email']) && isset($_POST['password'])) {
        $email = $conn->real_escape_string($_POST['email']);
        $password = $conn->real_escape_string($_POST['password']);

        // Query to check if user exists with the provided email and password
        $sql = "SELECT user_id, name, email FROM register WHERE email = '$email' AND password = '$password'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // User found, fetch user data
            $user = $result->fetch_assoc();

            // Send success response
            echo json_encode([
                "Status" => "True",
                "Message" => "Login successful.",
                "Data" => $user
            ]);
            http_response_code(200);
        } else {
            // Invalid credentials
            echo json_encode([
                "Status" => "False",
                "Message" => "Invalid email or password.",
                "Data" => []
            ]);
            http_response_code(401);
        }
    } else {
        // Missing email or password
        echo json_encode([
            "Status" => "False",
            "Message" => "Email and password are required.",
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
