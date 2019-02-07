using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.XR.MagicLeap;

namespace LR_Samples {
    public class SceneController : MonoBehaviour {

        #region Private Variables
        private MLInputController _controller; 
        private Ghost _ghost;
        #endregion

        # region Unity Methods
        void Awake () {

           _ghost = GetComponentInChildren<Ghost>(); 

            // Start Controller Input
            if (!MLInput.IsStarted) {
                MLInput.Start();
            }		

            _controller = MLInput.GetController(MLInput.Hand.Left);

            // Start Controller Callbacks
            MLInput.OnControllerButtonUp += _buttonUpCallback;
            MLInput.OnTriggerUp += _triggerUpCallback;

        }
        
        void OnDestroy() {

            // Stop Controller Callbacks
            MLInput.OnControllerButtonUp -= _buttonUpCallback;
            MLInput.OnTriggerUp -= _triggerUpCallback;

            // Stop Controller Input
            if (MLInput.IsStarted) {
                MLInput.Stop();
            }
        }
        #endregion

        # region Public Methods
        public void haptic_bump(MLInputControllerFeedbackIntensity force) {
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Bump, force);
        }
        public void haptic_buzz(MLInputControllerFeedbackIntensity force) {
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Buzz, force);
        }
        #endregion

        #region Event Handlers
        private void _buttonUpCallback(byte controller_id, MLInputControllerButton button) {

            // Callback - Hometap Up - reloads the Main scene
            if (button == MLInputControllerButton.HomeTap) {          
                    SceneManager.LoadScene(0);
            }
        }

        // Callback - Trigger Up -  Toggles freezing the ghost
        private void _triggerUpCallback(byte controllerId, float value) {
		    _ghost.ToggleFreeze();
        }
        #endregion
    }
}
