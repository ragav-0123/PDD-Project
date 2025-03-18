<?php
include('db.php'); // Include database connection
header('Content-Type: application/json');

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate required fields
    if (isset($_POST['email']) && isset($_POST['newpassword']) && isset($_POST['confirmpassword'])) {
        $email = $conn->real_escape_string($_POST['email']);
        $newpassword = $conn->real_escape_string($_POST['newpassword']);
        $confirmpassword = $conn->real_escape_string($_POST['confirmpassword']);

        // Check if new password matches confirm password
        if ($newpassword !== $confirmpassword) {
            echo json_encode([
                "Status" => "False",
                "Message" => "Passwords do not match.",
                "Data" => []
            ]);
            exit;
        }

        // Check if email exists
        $checkQuery = "SELECT user_id FROM register WHERE email = ?";
        $stmt = $conn->prepare($checkQuery);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows == 0) {
            echo json_encode([
                "Status" => "False",
                "Message" => "Email not found.",
                "Data" => []
            ]);
            $stmt->close();
            exit;
        }
        $stmt->close();

        // Update password
        $updateQuery = "UPDATE register SET password = ? WHERE email = ?";
        $stmt = $conn->prepare($updateQuery);
        $stmt->bind_param("ss", $newpassword, $email);

        if ($stmt->execute()) {
            echo json_encode([
                "Status" => "True",
                "Message" => "Password reset successfully.",
                "Data" => []
            ]);
        } else {
            echo json_encode([
                "Status" => "False",
                "Message" => "Error updating password.",
                "Data" => []
            ]);
        }
        $stmt->close();
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
