using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.XR.MagicLeap;

namespace LR_Samples {    
    namespace Main_Controller {
        public class LaserPointer : MonoBehaviour {

            # region Static GameObjects
            public static GameObject _buttonObject = null;
            #endregion

            # region Private GameObjects
            [SerializeField] private GameObject _Laser;
            [SerializeField] private GameObject _LaserBeam;
            [SerializeField] private GameObject _LaserDot;
            #endregion

            # region Private Variables
            private Vector3 _forward;
            private Vector3 _laserStart;
            private MLInputController _controller;
            private float _beamFade = 1.0f;

            [SerializeField, Tooltip("The laser dot size")]
            private float _dotSize = 0.001f;
            [SerializeField, Tooltip("The laser beam width")]
            private float _beamThickness = 0.005f;
            [SerializeField, Tooltip("The laser beam length")]    
            private float _beamLength = 15.0f;
            [SerializeField, Tooltip("The laser beam fade length")]    
            private float _beamFadeLength = 15.0f;
            [SerializeField, Tooltip("The laser beam offset from the controller")]    
            private float _beamOriginOffset = 0.01f;
            [SerializeField, Tooltip("The laser beam color")]    
            private Color _beamColor = Color.red;
            #endregion

            # region Unity Methods
            void OnDestroy() {
                MLInput.Stop();
            }

            void Start() {
                MLInput.Start();

                _controller = MLInput.GetController(MLInput.Hand.Left);
            }

            void Update() {

                // Get Controller Transform
                Vector3 p0 = _controller.Position;
                Quaternion q = _controller.Orientation;

                // Get forward vector
                _forward = (q * Vector3.forward).normalized;

                // Rotate Transform
                _Laser.transform.rotation = q * Quaternion.Euler(90.0f, 0.0f, 0.0f);

                // Offset Laser Start Position
                _laserStart = p0 + (_beamOriginOffset * _forward);

                // Update laser parameters
                updateParams();

                // Raycast laser and look for intersections
                intersectBeam();
            }
            #endregion

            # region Private Methods
            private void intersectBeam() {

                PointerEventData pointer = new PointerEventData(EventSystem.current);

                _buttonObject = null;
        
                RaycastHit hit;
                bool rayHitTest = Physics.Raycast(_laserStart, _forward, out hit, _beamLength);
                if (rayHitTest) {

                    // Set laser dot transform
                    _LaserDot.transform.position = hit.point;
                    _LaserDot.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit.normal);

                    // Set new laser beam length
                    float newLength = Vector3.Distance(hit.point, _laserStart);
                    _Laser.transform.localScale = new Vector3(_beamThickness, newLength, _beamThickness);

                    // Disable beam fade
                    _beamFade = 1.0f;

                    // Check if intersection with button, set button handlers for trigger callback
                    if (hit.transform.gameObject.GetComponentInChildren<Button>()) {
                        _buttonObject = hit.transform.gameObject;
                        ExecuteEvents.Execute(_buttonObject, pointer, ExecuteEvents.pointerEnterHandler);
                        ExecuteEvents.Execute(_buttonObject, pointer, ExecuteEvents.pointerExitHandler);
                    }
                }

                // No hit clear the button target
                else if (_buttonObject) {
                    ExecuteEvents.Execute(_buttonObject, pointer, ExecuteEvents.pointerExitHandler);
                    _buttonObject = null;
                }

                // Laser dot is active if laser hit a target
                _LaserDot.SetActive(rayHitTest);

                // Set laser fade
                Material laserMat = _LaserBeam.GetComponentInChildren<MeshRenderer>().materials[0];
                if (laserMat.HasProperty("_GradientFalloffUVs")) {
                    laserMat.SetFloat("_GradientFalloffUVs", _beamFade);
                }
            }

            private void updateParams() {

                // Set Beam offset
                _Laser.transform.position = _laserStart;

                // Set Beam Thickness
                _Laser.transform.localScale = new Vector3(_beamThickness, _beamLength, _beamThickness);

                // Set Beam Fade
                _beamFade = _beamLength / _beamFadeLength;

                // Set Laser Color
                Material laserMat = _LaserBeam.GetComponentInChildren<MeshRenderer>().materials[0];
                if (laserMat.HasProperty("_BeamColor")) {
                    laserMat.SetColor("_BeamColor", _beamColor);
                }

                // Set Laser Dot Scale
                _LaserDot.transform.localScale = new Vector3(_dotSize, _dotSize, _dotSize);

                // Set Laser Dot Color
                Material laserDotMat = _LaserDot.GetComponentInChildren<MeshRenderer>().materials[0];
                if (laserDotMat.HasProperty("_DotColor")) {
                    laserDotMat.SetColor("_DotColor", _beamColor);
                }
            }
            #endregion
        }
    }
}

