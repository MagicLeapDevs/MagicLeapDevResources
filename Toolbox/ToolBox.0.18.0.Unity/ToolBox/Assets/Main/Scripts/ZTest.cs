 using UnityEngine.UI;
using UnityEngine;

public class ZTest : MonoBehaviour {

public UnityEngine.Rendering.CompareFunction compare = UnityEngine.Rendering.CompareFunction.Always;

	void Awake () {
		Text text = GetComponent<Text>();
		Material existingMat = text.materialForRendering;
        Material updated = new Material(existingMat);
		updated.SetInt("unity_GUIZTestMode", (int)compare);
        text.material = updated;

	}
}
