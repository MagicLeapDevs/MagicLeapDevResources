using UnityEngine;
using System.Collections;

namespace LR_Samples {

    public class Vignette : MonoBehaviour {

        #region Public Variables
        public float VignettePower = 13.0f;
        public Material MatVignette;
        public GameObject Controller;
        #endregion

        #region Private Variables
        private SceneController _controller;
        private float _vignetteScale = 10.0f;
        private float _VIGNETTE_MIN = 1.0f;
        private float _VIGNETTE_MAX = 20.0f;  
        private enum _STATE {OFF=0, ON=1, MASK=2};
        private int _vignetteState = (int)_STATE.ON;
        #endregion
        
        #region Unity Methods
        void Start () {
            _controller = Controller.GetComponent<SceneController>();
        }

        void Update() {
            if (_controller.controller.Touch1PosAndForce.z > 0.0) {
                float deltaX = _controller.controller.Touch1PosAndForce.x;
                VignettePower -= deltaX * Time.deltaTime *  _vignetteScale;
                VignettePower = Mathf.Clamp(VignettePower, _VIGNETTE_MIN, _VIGNETTE_MAX);
            }
        }
        
        void OnRenderImage(RenderTexture srcTexture, RenderTexture destTexture) {
            MatVignette.SetFloat("_VignettePower", VignettePower);
            Graphics.Blit(srcTexture, destTexture, MatVignette);
        }
        #endregion

        #region public methods
        public void ToggleVignetteState() {
            _vignetteState++;
            _vignetteState = _vignetteState % 3;
            switch ((_STATE)_vignetteState) {
                case _STATE.OFF:
                    enabled = false;
                    break;
                case _STATE.ON:
                    enabled = true;
                    MatVignette.SetInt("_VignetteMode", (int)_STATE.ON);
                    break;
                case _STATE.MASK:
                    enabled = true;
                    MatVignette.SetInt("_VignetteMode", (int)_STATE.MASK);
                    break;
            }
        }

        public void Reset() {
            _vignetteState = (int)_STATE.MASK;
            ToggleVignetteState();
        }
        #endregion
    }
}
