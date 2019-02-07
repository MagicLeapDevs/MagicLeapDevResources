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

        # region Unity Methods
        void Start() { 

            // Start Controller Input
            if (!MLInput.IsStarted) {
                MLInput.Start();
            }

            controller = MLInput.GetController(MLInput.Hand.Left);

            // Start Controller Callbacks
            MLInput.OnControllerButtonUp += _resetCallback;
            MLInput.OnTriggerUp += nextSceneCallback;

            resetScene();		
        }

        void Update() { 
        }
        
        void OnDestroy() {

            // Stop Controller Callbacks
            MLInput.OnControllerButtonUp -= _resetCallback;
            MLInput.OnTriggerUp -= nextSceneCallback;

            // Stop Controller Input
            if (MLInput.IsStarted) {
                MLInput.Stop();
            }
        }
        #endregion

        # region Private Methods
        // Position the objects of each scene in front of the camera, using only the y-comp of the rotation
        public void resetScene() {
            Camera mainCamera = Camera.main;

            GameObject sceneObject = GameObject.FindGameObjectWithTag("sceneObject");
            if (sceneObject != null) {
                sceneObject.transform.position = mainCamera.transform.position;
                sceneObject.transform.rotation = Quaternion.Euler(0f, mainCamera.transform.rotation.eulerAngles.y, 0f);
            }                
        }
        #endregion

        #region Event Handlers
        // Callback - Hometap reloads the Main scene
        private void _resetCallback(byte controller_id, MLInputControllerButton button) {
            if (button == MLInputControllerButton.HomeTap) {          
                SceneManager.LoadScene(0);
            }
            if (button == MLInputControllerButton.Bumper) {
                resetScene();
            }         
        }

        // Callback - Trigger - loads the next scene
        private void nextSceneCallback(byte controllerId, float value) {
            int sceneIndex = SceneManager.GetActiveScene().buildIndex;
            int newSceneIndex = sceneIndex + 1;
            if (newSceneIndex >= SceneManager.sceneCountInBuildSettings) {
                newSceneIndex = 1;
            }
            SceneManager.LoadScene(newSceneIndex);
        }
        #endregion
    }
}


