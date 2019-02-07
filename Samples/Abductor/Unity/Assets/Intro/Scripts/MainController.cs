using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;
using UnityEngine.XR.MagicLeap;

namespace LR_Samples {
    namespace Main_Controller {
        public class MainController : MonoBehaviour {

            # region Private Variables
            [SerializeField] GameObject _Pages;
            [SerializeField] GameObject _Panel;

            [SerializeField] Camera _Camera;
            [SerializeField] bool _hideBackground = false;

            private int _pageIndex = 0;
            private List<GameObject> _pages = new List<GameObject>();
            #endregion

            # region Unity Methods
            void Start () {

                // Start Controller input
                if (!MLInput.IsStarted) {
                    MLInput.Start();
                }

                // Start Controller Callbacks
                MLInput.OnControllerButtonUp += _resetCallback;
                MLInput.OnTriggerUp += HandleOnTriggerUp;

                // Store the pages in a list
                for (int i=0;i<_Pages.transform.childCount;i++) {
                    _pages.Add(_Pages.transform.GetChild(i).gameObject);
                }

                // Hide background with a panel
                _Panel.SetActive(_hideBackground);
            }
            
            void OnDestroy() {

                // Stop Controller Callbacks
                MLInput.OnControllerButtonUp -= _resetCallback;
                MLInput.OnTriggerUp -= HandleOnTriggerUp;

                // Stop Controller input
                if (MLInput.IsStarted) {
                    MLInput.Stop();
                }
            }

            void Update () {
                _updateTransform();
            }
            #endregion

            # region Private Methods
            // Update the transform to softlock the content to the headpose
            private void _updateTransform() {
                float speed = Time.deltaTime * 5f;

                Vector3 pos = _Camera.transform.position + _Camera.transform.forward *1.0f;
                gameObject.transform.position = Vector3.SlerpUnclamped(gameObject.transform.position, pos, speed);

                Quaternion rot = Quaternion.LookRotation(gameObject.transform.position - _Camera.transform.position);
                gameObject.transform.rotation = Quaternion.Slerp(gameObject.transform.rotation, rot, speed);        
            }

            // Load the next scene in the build settings
            private void nextScene() {
                int sceneIndex = SceneManager.GetActiveScene().buildIndex;
                SceneManager.LoadScene(sceneIndex + 1);
            }
            #endregion

            # region Public Methods
            // Advance through the Page list, setting only the current page visible
            public void selectNextButton() {
                _pageIndex++;
            if (_pageIndex >= _pages.Count) {
                    nextScene();
                }
                else {
                    for (int i=0;i<_pages.Count;i++) {
                        _pages[i].SetActive(i == _pageIndex);
                    }              
                }
            } 
            public void legalScreen() {
                string url = "http://www.magicleap.com/legal/privacy";
                MLDispatcher.TryOpenAppropriateApplication(url);
            }
 
            // Advance through the Page Hierarchy, setting the current page visible
            /*public void selectNextButton() {
                int childCount = _Pages.transform.childCount;
                for (int i=0;i<childCount;i++) {
                    if (_Pages.transform.GetChild(i).gameObject.activeSelf) {
                        if (i >= childCount-1) {
                            nextScene();
                        }
                        else {
                            _Pages.transform.GetChild(i).gameObject.SetActive(false);
                            _Pages.transform.GetChild(i+1).gameObject.SetActive(true);
                        }
                        break;
                    }
                }
            }*/ 
            #endregion

            #region Event Handlers
            // Callback - Hometap reloads the Main scene
            private void _resetCallback(byte controller_id, MLInputControllerButton button) {
            if (button == MLInputControllerButton.HomeTap) {          
                    SceneManager.LoadScene(0, LoadSceneMode.Single);
                }
            }

            // Callback - Trigger activates button method if a button object is selected
            private void HandleOnTriggerUp(byte controllerId, float value) {
                if (LaserPointer._buttonObject != null) {
                    PointerEventData pointer = new PointerEventData(EventSystem.current);
                    ExecuteEvents.Execute(LaserPointer._buttonObject, pointer, ExecuteEvents.submitHandler);
                }
            }
            #endregion
        }
    }
}