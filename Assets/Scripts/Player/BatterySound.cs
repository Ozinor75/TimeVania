using FMOD.Studio;
using FMODUnity;
using UnityEngine;

public class BatterySound : MonoBehaviour
{
    [Header("Prefabs")] 
    public EventReference loseCharge;
    public EventReference tickingTimer;
    
    private EventInstance loseChargeInstance;
    private EventInstance tickingTimerInstance;
    
    private BatteryManager batteryManager;
    
    public void PlayOneShot(EventInstance instance, EventReference eventReference, Vector3 position, float volume = 1f)
    {
        instance = FMODUnity.RuntimeManager.CreateInstance(eventReference);
        instance.set3DAttributes(RuntimeUtils.To3DAttributes(position));
        instance.setVolume(volume);
        instance.start();
        instance.release();
    }
    
    public bool IsPlaying (EventInstance instance) 
    {
        PLAYBACK_STATE state;   
        instance.getPlaybackState(out state);
        return state != PLAYBACK_STATE.STOPPED;
    }
    
    public void TickingTimer(bool on)
    {
        if (on)
        {
            if (!IsPlaying(tickingTimerInstance))
                PlayOneShot(tickingTimerInstance, tickingTimer, transform.position, 1F);
        }
        else
        {
            if (IsPlaying(tickingTimerInstance))
                tickingTimerInstance.stop(0);
        }
    }
    public void LoseCharge()
    {
        PlayOneShot(loseChargeInstance, loseCharge, transform.position, 1f);
    }
    void Start()
    {
        batteryManager = GetComponent<BatteryManager>();
    }

    // Update is called once per frame
    void Update()
    {
    }
}
