<?php
include('db.php');
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['email'])) {
        $email = $_POST['email'];
        $newName = !empty($_POST['name']) ? trim($_POST['name']) : null;
        $newEmail = !empty($_POST['new_email']) ? trim($_POST['new_email']) : null;
        $newPassword = !empty($_POST['password']) ? trim($_POST['password']) : null;

        // Check if the email exists
        $checkQuery = "SELECT user_id FROM register WHERE email = ?";
        $stmt = $conn->prepare($checkQuery);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows === 0) {
            echo json_encode([
                "Status" => "False",
                "Message" => "Email not found in the database.",
                "Data" => []
            ]);
            $stmt->close();
            exit;
        }
        $stmt->close();

        // Update fields accordingly
        $updateFields = [];
        $params = [];
        $types = "";

        if ($newName) {
            $updateFields[] = "name = ?";
            $params[] = $newName;
            $types .= "s";
        }
        if ($newEmail) {
            $updateFields[] = "email = ?";
            $params[] = $newEmail;
            $types .= "s";
        }
        if ($newPassword) {
            $updateFields[] = "password = ?";
            $params[] = $newPassword;
            $types .= "s";
        }

        if (empty($updateFields)) {
            echo json_encode([
                "Status" => "False",
                "Message" => "No data provided for update.",
                "Data" => []
            ]);
            exit;
        }

        // Construct query
        $query = "UPDATE register SET " . implode(", ", $updateFields) . " WHERE email = ?";
        $params[] = $email;
        $types .= "s";

        $stmt = $conn->prepare($query);
        $stmt->bind_param($types, ...$params);

        if ($stmt->execute()) {
            $stmt->close();

            // Fetch updated profile data
            $updatedEmail = $newEmail ? $newEmail : $email; // Use new email if updated
            $fetchQuery = "SELECT user_id, name, email FROM register WHERE email = ?";
            $stmt = $conn->prepare($fetchQuery);
            $stmt->bind_param("s", $updatedEmail);
            $stmt->execute();
            $result = $stmt->get_result();
            $updatedUser = $result->fetch_assoc();
            $stmt->close();

            echo json_encode([
                "Status" => "True",
                "Message" => "Profile updated successfully.",
                "Data" => $updatedUser
            ]);
        } else {
            echo json_encode([
                "Status" => "False",
                "Message" => "Error updating profile: " . $conn->error,
                "Data" => []
            ]);
        }
    } else {
        echo json_encode([
            "Status" => "False",
            "Message" => "Missing required field: email.",
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
