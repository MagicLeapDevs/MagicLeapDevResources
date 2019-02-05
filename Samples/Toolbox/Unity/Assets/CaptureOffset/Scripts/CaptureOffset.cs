using UnityEngine;
using System.Collections;
public class CaptureOffset : MonoBehaviour {

    #region Public Variables
    public Material captureOffsetMaterial;
    #endregion

	#region Private Variables
    private GameObject _appManager;
    private Controller _controller;
	private float _offsetU = 0.0f;
    private float _offsetV = 0.0f;
	#endregion
	
    #region Unity Methods
	void Start () {
        _appManager = GameObject.Find("AppManager");
        _controller = _appManager.GetComponent<Controller>();
	}

    void Update() {
        if (_controller._controller.Touch1PosAndForce.z > 0.0) {
            _offsetU += _controller._controller.Touch1PosAndForce.x;
            _offsetV -= _controller._controller.Touch1PosAndForce.y;
        }
    }
	
	void OnRenderImage(RenderTexture srcTexture, RenderTexture destTexture) {
		captureOffsetMaterial.SetFloat("_OffsetU", _offsetU);
		captureOffsetMaterial.SetFloat("_OffsetV", _offsetV);
		Graphics.Blit(srcTexture, destTexture, captureOffsetMaterial);
	}
	#endregion
}
