using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneObjects : MonoBehaviour {

	void Start () {
        resetScene();		
	}

    // Position the objects of each scene in front of the camera, using only the y-comp of the rotation
    public void resetScene() {
        Camera mainCamera = Camera.main;

        GameObject sceneObject = GameObject.FindGameObjectWithTag("sceneObject");
        if (sceneObject != null) {
            sceneObject.transform.position = mainCamera.transform.position;
            sceneObject.transform.rotation = Quaternion.Euler(0f, mainCamera.transform.rotation.eulerAngles.y, 0f);
        }                
    }
}
