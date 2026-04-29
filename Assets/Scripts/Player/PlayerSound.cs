using FMOD.Studio;
using FMODUnity;
using UnityEngine;

public class PlayerSound : MonoBehaviour
{
    [Header("Cooldowns")] 
    public float footStepCooldown;

    [Header("Prefabs")] 
    public EventReference footsteps;
    public EventReference jump;
    public EventReference swift;
    public EventReference slow;
    public EventReference dash;
    public EventReference activateStation;
    public EventReference death;
    public EventReference hurt;
    public EventReference reload;
    public EventReference start;
    
    private PlayerController player;
    private float t = 0f;
    
    public void PlayOneShot(EventReference eventReference, Vector3 position, float volume = 1f)
    {
        EventInstance instance = FMODUnity.RuntimeManager.CreateInstance(eventReference);
        instance.set3DAttributes(RuntimeUtils.To3DAttributes(position));
        instance.setVolume(volume);
        instance.start();
        instance.release();
    }
    public void HurtSound()
    {
        PlayOneShot(hurt, transform.position, 1f);
    }
    public void Reload()
    {
        PlayOneShot(reload, transform.position, 1f);
    }
    
    public void StartSound()
    {
        if (!start.IsNull)
            PlayOneShot(start, transform.position, 1f);
    }
    public void StopSound(AudioSource sound)
    {
        sound.Stop();
    }

    public void Death()
    {
        if (!death.IsNull)
            PlayOneShot(death, transform.position, 1f);
    }
    public void Mid()
    {
        
    }
    public void Slow()
    {
        PlayOneShot(slow, transform.position, 1f);
    }
    
    public void Swift()
    {
        PlayOneShot(swift, transform.position, 1f);
    }
    
    public void Dash()
    {
        PlayOneShot(dash, transform.position, 1f);
    }
    
    public void Jump()
    {
        PlayOneShot(jump, transform.position, 1f);
    }
    public void FootSteps()
    {
        PlayOneShot(footsteps, transform.position, 1f);
    }
    
    public void ActivateStation()
    {
        PlayOneShot(activateStation, transform.position, 1f);
    }
    void Start()
    {
        player = transform.parent.GetComponent<PlayerController>();
    }
    void Update()
    {
        if (player.isGrounded)
            if (player.rb.linearVelocityX > 0.05f || player.rb.linearVelocityX < -0.05f)
                t += Time.deltaTime;
        if (t >= footStepCooldown)
        {
            FootSteps();
            t = 0f;
        }
    }
}
