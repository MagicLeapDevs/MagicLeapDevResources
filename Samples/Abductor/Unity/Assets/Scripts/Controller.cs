using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.MagicLeap;

namespace MagicLeap
{
    public class Controller : MonoBehaviour {

        public MLInputController _controller;
        public bool bumperUp = false;
        public bool homeButtonPressed = false;
        public Timer bumperTimer = new Timer();
        public bool triggerEnabled = false;
        public bool okGesture = false;
        private float _TRIGGER_THRESHOLD = 0.2f;

// Gestures
        private MLHandKeyPose gestureOK;
        private MLHandKeyPose[] gestures;

        void Awake() {
            var result = MLInput.Start(); 
            if (!result.IsOk) {
                Debug.LogError("Error ControllerCalibration starting MLInput, disabling script.");
                enabled = false;
                return;
            }

            result = MLHands.Start();
            if (!result.IsOk) {
                Debug.LogError("Error ControllerCalibration starting MLInput, disabling script.");
                enabled = false;
                return;                
            }
        }
        
        void Start() {
            _controller = MLInput.GetController(MLInput.Hand.Left);
            MLInput.OnControllerButtonDown += OnButtonDown;
            MLInput.OnControllerButtonUp += OnButtonUp;
        }

        void OnDestroy() {
            MLInput.Stop();
            MLHands.Stop();
        }
        
        void OnButtonDown(byte controller_id, MLInputControllerButton button) {
            if (button == MLInputControllerButton.Bumper) {   
                bumperTimer.start();
            }
        }

        void OnButtonUp(byte controller_id, MLInputControllerButton button) {
            if (button == MLInputControllerButton.Bumper) {  
                bumperTimer.stop();
                bumperUp = true;
            }
            else if (button == MLInputControllerButton.HomeTap) {          
                homeButtonPressed = true;
            }
        }

        public void setupGestures() {
            // Load up only gesture - OK
            gestureOK = MLHandKeyPose.Ok;
            gestures = new MLHandKeyPose[1]; 
            gestures[0] = MLHandKeyPose.Ok;
            MLHands.KeyPoseManager.EnableKeyPoses(gestures, true, false);
        }

        public void updateGestureStates() {
            // Update gesture states
            MLHand[] _hands = {MLHands.Left, MLHands.Right};
            foreach (MLHand hand in _hands) {
                if (hand.KeyPose == gestureOK) {
                    if (hand.KeyPoseConfidence > 0.9f) {
                        okGesture = true;
                    }
                }
            }
        }

        public void resetFrame() {
            bumperUp = false;
            homeButtonPressed = false;
            okGesture = false;            
        }

        public bool trigger {
            get {return _controller.TriggerValue >= _TRIGGER_THRESHOLD;}
         }

        public void haptic_forceDown(MLInputControllerFeedbackIntensity force) {
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.ForceDown, force);
        }
        public void haptic_forceUp(MLInputControllerFeedbackIntensity force) {
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.ForceUp, force);
        }
        public void haptic_tick(MLInputControllerFeedbackIntensity force) {
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Tick, force);
        }
        public void haptic_bump(MLInputControllerFeedbackIntensity force) {
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Bump, force);
        }
    }
}
