using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.XR.MagicLeap;

namespace LR_Samples {
    public class SceneController : MonoBehaviour {

	    #region Public Variables
        public MLInputController controller; 
        #endregion

	    #region Private Variables
        [SerializeField] GameObject _Meshing;
        [SerializeField] GameObject _Spawner;
        [SerializeField] GameObject _UFO;

        private MLHandKeyPose gestureOK;
        private MLHandKeyPose[] gestures;
        private Meshing _meshing;
        private Spawner _spawner;
        private Timer _bumperTimer = new Timer();
        private bool _okGesture = false;
        private const float _BUMPER_MESHING_MAX = 5f;
        #endregion

        # region Unity Methods
        void Awake () {

            // Start Controller Input
            if (!MLInput.IsStarted) {
                MLInput.Start();
            }

            // Start Hands Input
            if (!MLHands.IsStarted) {
                MLHands.Start();
            }		

			controller = MLInput.GetController(MLInput.Hand.Left);

            // Start Controller Callbacks
            MLInput.OnControllerButtonUp += _buttonUpCallback;
            MLInput.OnControllerButtonDown += _buttonDownCallback;

            _meshing = _Meshing.GetComponentInChildren<Meshing>();
            _spawner = _Spawner.GetComponentInChildren<Spawner>();

            // Load up game gestures
            _setupGestures();

            _initUFO();
        }
        
        void OnDestroy() {

            // Stop Controller Callbacks
            MLInput.OnControllerButtonUp -= _buttonUpCallback;
            MLInput.OnControllerButtonDown -= _buttonDownCallback;

            // Stop Controller Input
            if (MLInput.IsStarted) {
                MLInput.Stop();
            }

            // Stop Hands Input
            if (MLHands.IsStarted) {
                MLHands.Stop();
            }
        }

        void LateUpdate() {
            // Update gesture states for this frame
            _updateGestureStates();

            // OK gesture will spawn space kitties and place UFO
            if (_okGesture && !_spawner._prefabsPopulated) {
                haptic_forceDown(MLInputControllerFeedbackIntensity.Low);          
                _populatePrefabs();
                _initUFO();
            }

            // Handle bumper timer to see if meshing is being toggled 
            _handleBumper();

        }
        #endregion

        # region Public Methods
        public void haptic_forceDown(MLInputControllerFeedbackIntensity force) {
            controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.ForceDown, force);
        }
        public void haptic_forceUp(MLInputControllerFeedbackIntensity force) {
            controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.ForceUp, force);
        }
        public void haptic_tick(MLInputControllerFeedbackIntensity force) {
            controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Tick, force);
        }
        public void haptic_bump(MLInputControllerFeedbackIntensity force) {
            controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Bump, force);
        }
        #endregion

        # region Private Methods

        // Set gestures - only gesture is OK
        private void _setupGestures() {
            // Load up only gesture - OK
            gestureOK = MLHandKeyPose.Ok;
            gestures = new MLHandKeyPose[1]; 
            gestures[0] = MLHandKeyPose.Ok;
            MLHands.KeyPoseManager.EnableKeyPoses(gestures, true, false);
        }

        // Look for OK gesture from either hand
        private void _updateGestureStates() {
            MLHand[] _hands = {MLHands.Left, MLHands.Right};
            foreach (MLHand hand in _hands) {
                if (hand.KeyPose == gestureOK) {
                    if (hand.KeyPoseConfidence > 0.9f) {
                        _okGesture = true;
                    }
                }
            }
        }

        // Create the prefabs, hide the spawner box volume
        private void _populatePrefabs() {
            _spawner.populatePrefabs();
        }

        // Start the UFO in the correct location
        private void _initUFO() {
            SimpleMove simpleMove = _UFO.GetComponentInChildren<SimpleMove>();
            simpleMove.initPosition(_Spawner.transform.position);
        }

        // Toggle Mesh Scanning - holding down bumper for 5 secs
        private void _handleBumper() {
            if (_bumperTimer.getTime() >= _BUMPER_MESHING_MAX) {
                _meshing.toggleMeshScanning();
                _bumperTimer.stop();
            }
        }
        #endregion

        #region Event Handlers
        // Callback - Hometap reloads the Main scene
        private void _buttonUpCallback(byte controller_id, MLInputControllerButton button) {
            if (button == MLInputControllerButton.HomeTap) {
                haptic_forceDown(MLInputControllerFeedbackIntensity.High);          
                SceneManager.LoadScene(0);
            }
            else if (button == MLInputControllerButton.Bumper) {
                if (_bumperTimer.isRunning()) {
                    // Toggle mesh visibility - bumper held down less than 5 secs
                    if (_bumperTimer.getTime() < _BUMPER_MESHING_MAX) {
                        _meshing.toggleMeshVisibility();
                    }
                    _bumperTimer.stop();
                }
            }
        }

        private void _buttonDownCallback(byte controller_id, MLInputControllerButton button) {
            if (button == MLInputControllerButton.Bumper) {
                _bumperTimer.start();
            }
        }
        #endregion
    }
}
