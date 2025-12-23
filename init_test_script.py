from ultralytics import YOLO
import cv2

# 1. Load the model (YOLOv8 nano is very fast for live video)
# It will automatically download the 'yolov8n.pt' file on first run
model = YOLO('yolov8n.pt') 

# 2. Move the model to the GPU
model.to('cuda')

# 3. Initialize the webcam
cap = cv2.VideoCapture(0)

print("Starting YOLO GPU detection... Press 'q' to stop.")

while cap.isOpened():
    success, frame = cap.read()
    if not success:
        break

    # 4. Run inference
    # classes=[0] restricts detection specifically to "person"
    results = model(frame, stream=True, conf=0.75, classes=[0], device=0, verbose=False)

    # 5. Visualize the results on the frame
    for r in results:
        annotated_frame = r.plot()

    # 6. Display the output
    cv2.imshow("Camera Feed", annotated_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()