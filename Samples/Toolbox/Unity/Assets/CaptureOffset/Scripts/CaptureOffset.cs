using UnityEngine;
using System.Collections;

namespace LR_Samples {
    public class CaptureOffset : MonoBehaviour {

        #region Public Variables
        public Material captureOffsetMaterial;
        #endregion

        #region Private Variables
        private SceneController _sceneController;
        private float _offsetU = 0.0f;
        private float _offsetV = 0.0f;
        #endregion
        
        #region Unity Methods
        void Start () {
            _sceneController = GetComponentInChildren<SceneController>();
        }

        void Update() {
            if (_sceneController.controller.Touch1PosAndForce.z > 0.0) {
                _offsetU += _sceneController.controller.Touch1PosAndForce.x;
                _offsetV -= _sceneController.controller.Touch1PosAndForce.y;
            }
        }
        
        void OnRenderImage(RenderTexture srcTexture, RenderTexture destTexture) {
            captureOffsetMaterial.SetFloat("_OffsetU", _offsetU);
            captureOffsetMaterial.SetFloat("_OffsetV", _offsetV);
            Graphics.Blit(srcTexture, destTexture, captureOffsetMaterial);
        }
        #endregion
    }
}
