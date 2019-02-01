using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowCamera : MonoBehaviour {

    #region Public variables
    public Transform mainCam;
    public float offset;
    #endregion
	
    #region Unity Methods
	void Update () {
		transform.position = new Vector3(mainCam.position.x, mainCam.position.y + offset, mainCam.position.z);
	}
    #endregion
}
