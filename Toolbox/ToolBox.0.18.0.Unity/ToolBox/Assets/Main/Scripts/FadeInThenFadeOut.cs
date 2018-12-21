using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadeInThenFadeOut : MonoBehaviour {
    public Text text;
	private float time;
	private float Limit=2.0f;
	private float semiLimit;
	private float alpha;
	void Start () {
	 time = 0.001f;
	 semiLimit = Limit / 2.0f;
	}
	
	void Update () {
		if (time >= Limit) {
			time = 0.001f;
		}
		time += Time.deltaTime;

		if (time<=semiLimit) {
			alpha = time / semiLimit;
		}
		else {
			alpha = 1f - (time - semiLimit)/semiLimit;
		}
		
		text.GetComponent<CanvasRenderer>().SetAlpha(alpha);
	}
}
