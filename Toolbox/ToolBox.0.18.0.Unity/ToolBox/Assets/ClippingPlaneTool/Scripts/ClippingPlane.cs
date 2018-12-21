using UnityEngine;
using System.Collections;
public class ClippingPlane : MonoBehaviour {

    #region Public Variables
    public Material clippingPlaneMaterial;
    #endregion
	
    #region Unity Methods
    private void Start() {
        // Enable camera z-depth buffer
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
    }
	   
	void OnRenderImage(RenderTexture srcTexture, RenderTexture destTexture) {
        // Post Process Shader - Render depth-based color on all scene objects
		Graphics.Blit(srcTexture, destTexture, clippingPlaneMaterial);
	}
    #endregion
}
