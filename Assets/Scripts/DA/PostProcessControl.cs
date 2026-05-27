using System.Collections;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PostProcessControl : MonoBehaviour
{
    private PostProcessProfile camProfile;

    public float SlowDistortionStr;
    public float SpeedDistortionStr;
    public float BaseDistortionStr;
    
    
    void Start()
    {
        camProfile = GetComponent<PostProcessVolume>().profile;
        ResetParameters();
    }

    public void SetSlowedParameters()
    {
        camProfile.GetSetting<ColorGrading>().saturation.value = SlowDistortionStr;
    }

    public void SetAccelParameters()
    {
        camProfile.GetSetting<ColorGrading>().saturation.value = SpeedDistortionStr;
    }

    public void ResetParameters()
    {
        camProfile.GetSetting<ColorGrading>().saturation.value = BaseDistortionStr;
    }
}
