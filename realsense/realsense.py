import pyrealsense2 as rs
import numpy as np
import cv2
import time

# Initialize the pipeline
pipeline = rs.pipeline()
config = rs.config()

# Enable streams
config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)
config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# Start pipeline
pipeline.start(config)

try:
    while True:
        try:
            # Wait for frames, add a longer timeout if necessary
            frames = pipeline.wait_for_frames(timeout_ms=10000)
            depth_frame = frames.get_depth_frame()
            color_frame = frames.get_color_frame()

            if not depth_frame or not color_frame:
                print("Frames not received. Retrying...")
                continue

            # Convert frames to numpy arrays
            depth_image = np.asanyarray(depth_frame.get_data())
            color_image = np.asanyarray(color_frame.get_data())

            # Display images
            cv2.imshow('Depth Image', depth_image)
            cv2.imshow('Color Image', color_image)

            # Break if 'q' is pressed
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

        except RuntimeError as e:
            print(f"RuntimeError: {e}. Retrying in 1 second...")
            time.sleep(1)  # Wait before retrying

finally:
    # Stop the pipeline
    pipeline.stop()
    cv2.destroyAllWindows()
