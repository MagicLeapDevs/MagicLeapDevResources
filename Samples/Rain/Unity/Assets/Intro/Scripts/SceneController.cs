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
        [SerializeField] Camera _camera;
        private AudioSource _rainSound;
        private Vignette _vignette;
        #endregion

        # region Unity Methods
        void Awake () {

            // Start Controller Input
            if (!MLInput.IsStarted) {
                MLInput.Start();
            }		

			controller = MLInput.GetController(MLInput.Hand.Left);
            _vignette = _camera.GetComponentInChildren<Vignette>();
            _rainSound = _camera.GetComponentInChildren<AudioSource>();
            

            // Start Controller Callbacks
            MLInput.OnControllerButtonUp += _resetCallback;

            _rainSound.Play();
        }
        
        void OnDestroy() {

            _rainSound.Stop();

            // Stop Controller Callbacks
            MLInput.OnControllerButtonUp -= _resetCallback;

            // Stop Controller Input
            if (MLInput.IsStarted) {
                MLInput.Stop();
            }
        }
        #endregion

        #region Event Handlers
        // Callback - Hometap reloads the Main scene
        private void _resetCallback(byte controller_id, MLInputControllerButton button) {
            if (button == MLInputControllerButton.HomeTap) {          
                SceneManager.LoadScene(0);
            }
            else if (button == MLInputControllerButton.Bumper) {          
                _vignette.ToggleVignetteState();
                controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Bump, MLInputControllerFeedbackIntensity.High);
            } 
        }                   
       #endregion
    }
}
