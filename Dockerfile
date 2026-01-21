FROM archlinux:base-devel

# Install git and other essentials
RUN pacman -Syu --noconfirm base-devel git

# Create runner user matching GitHub Actions UID/GID
RUN groupadd -g 1001 runner && \
    useradd -u 1001 -g 1001 -m runner

# Configure sudoers for passwordless package management
RUN echo 'runner ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers.d/runner && \
    echo 'runner ALL=(ALL) NOPASSWD: /usr/bin/yay' >> /etc/sudoers.d/runner && \
    chmod 0440 /etc/sudoers.d/runner

# Create and own /workspace
RUN mkdir -p /workspace && \
    chown -R runner:runner /workspace

USER runner

# Install yay for AUR support
RUN cd /tmp && \
    git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm

# Update all packages
RUN yay -Syu --noconfirm

WORKDIR /workspace