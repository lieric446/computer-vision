import cv2

# 1. Initialize the camera (0 is usually the default built-in webcam)
cap = cv2.VideoCapture(0)

# Check if the webcam is opened correctly
if not cap.isOpened():
    print("Error: Could not open video device.")
    exit()

print("Camera turned on. Press 'q' to quit.")

while True:
    # 2. Capture frame-by-line
    ret, frame = cap.read()

    # If the frame was captured successfully, ret will be True
    if not ret:
        print("Error: Can't receive frame. Exiting...")
        break

    # 3. Display the resulting frame
    cv2.imshow('Webcam Feed', frame)

    # 4. Wait for the 'q' key to be pressed to exit the loop
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# 5. Release the capture and close windows
cap.release()
cv2.destroyAllWindows()